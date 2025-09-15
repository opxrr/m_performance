import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:m_performance/admin/admin_custom_widgets/search_button.dart';
import 'package:m_performance/admin/admin_custom_widgets/search_field.dart';
import 'package:m_performance/m_database/models/car.dart';
import 'package:m_performance/m_database/models/part.dart';
import 'package:m_performance/m_database/models/user.dart';
import 'package:m_performance/m_database/car_manager.dart';
import 'package:m_performance/m_database/part_manager.dart';
import 'package:m_performance/m_database/database_manager.dart';
import 'admin_custom_widgets/dialogs.dart';
import 'admin_custom_widgets/operation_button.dart';
import 'admin_custom_widgets/result_text.dart';
import 'admin_custom_widgets/search_type.dart';

class AdminPanel extends StatefulWidget {
  static const String routeName = 'adminPanel';

  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> with SingleTickerProviderStateMixin {
  final CarManager carManager = CarManager();
  final PartManager partManager = PartManager();
  final UserTable userTable = UserTable(DatabaseManager());
  final TextEditingController searchController = TextEditingController();
  List<Car> cars = [];
  List<Part> parts = [];
  List<User> users = [];
  List<Car> filteredCars = [];
  List<Part> filteredParts = [];
  List<User> filteredUsers = [];
  String result = '';
  bool isLoading = false;
  int _selectedTabIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadAllData();
    searchController.addListener(_filterItems);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedTabIndex = _tabController.index;
        searchController.clear();
        _filterItems();
      });
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_filterItems);
    searchController.dispose();
    carManager.dispose();
    partManager.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _loadAllData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final loadedCars = await carManager.getAllCars();
      final loadedParts = await partManager.getAllParts();
      final loadedUsers = await userTable.getAllUsers();
      setState(() {
        cars = loadedCars;
        parts = loadedParts;
        users = loadedUsers;
        filteredCars = loadedCars;
        filteredParts = loadedParts;
        filteredUsers = loadedUsers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        result = 'Error loading data: $e';
        isLoading = false;
      });
      _showAwesomeSnackbar('Error', 'Error loading data: $e', ContentType.failure);
    }
  }

  void _filterItems() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (_selectedTabIndex == 0) {
        filteredCars = cars.where((car) => car.modelName.toLowerCase().contains(query)).toList();
      } else if (_selectedTabIndex == 1) {
        filteredParts = parts.where((part) => part.partName.toLowerCase().contains(query)).toList();
      } else {
        filteredUsers = users
            .where((user) => user.name.toLowerCase().contains(query) || user.email.toLowerCase().contains(query))
            .toList();
      }
      result = '';
    });
  }

  void _showAwesomeSnackbar(String title, String message, ContentType type) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: type,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _showProductActionDialog(BuildContext context, dynamic product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF232020),
          title: Text(
            product is Car ? 'Manage Car: ${product.modelName}' : 'Manage Part: ${product.partName}',
            style: const TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Choose an action for this product:',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (product is Car) {
                  Dialogs.showUpdateCarDialog(
                    context: context,
                    carManager: carManager,
                    car: product,
                    onSuccess: () {
                      _loadAllData();
                      _showAwesomeSnackbar('Success', 'Car updated!', ContentType.success);
                    },
                  );
                } else if (product is Part) {
                  Dialogs.showUpdatePartDialog(
                    context: context,
                    partManager: partManager,
                    part: product,
                    onSuccess: () {
                      _loadAllData();
                      _showAwesomeSnackbar('Success', 'Part updated!', ContentType.success);
                    },
                  );
                }
              },
              child: const Text('Update', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (product is Car) {
                  Dialogs.showDeleteCarDialog(
                    context: context,
                    carManager: carManager,
                    onSuccess: () {
                      _loadAllData();
                      _showAwesomeSnackbar('Success', 'Car deleted!', ContentType.success);
                    },
                  );
                } else if (product is Part) {
                  Dialogs.showDeletePartDialog(
                    context: context,
                    partManager: partManager,
                    onSuccess: () {
                      _loadAllData();
                      _showAwesomeSnackbar('Success', 'Part deleted!', ContentType.success);
                    },
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Panel',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 4,
        shadowColor: Colors.indigoAccent,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.blueAccent,
          tabs: const [
            Tab(text: 'Cars'),
            Tab(text: 'Parts'),
            Tab(text: 'Users'),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/admin/adminBackground.jpg',
              color: Colors.black45,
              colorBlendMode: BlendMode.darken,
              fit: BoxFit.cover,
            ),
          ),
          TabBarView(
            controller: _tabController,
            children: [
              _buildCarsTab(),
              _buildPartsTab(),
              _buildUsersTab(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarsTab() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCarOperationButtons(),
              const SizedBox(height: 16),
              _buildSearchField(),
              const SizedBox(height: 8),
              _buildSearchButton(),
              const SizedBox(height: 16),
              if (result.isNotEmpty) _buildResultText(),
              const Text(
                'Cars List:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              isLoading ? const Center(child: CircularProgressIndicator()) : _buildCarsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartsTab() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPartOperationButtons(),
              const SizedBox(height: 16),
              _buildSearchField(),
              const SizedBox(height: 8),
              _buildSearchButton(),
              const SizedBox(height: 16),
              if (result.isNotEmpty) _buildResultText(),
              const Text(
                'Parts List:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              isLoading ? const Center(child: CircularProgressIndicator()) : _buildPartsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildUserOperationButtons(),
              const SizedBox(height: 16),
              _buildSearchField(),
              const SizedBox(height: 8),
              _buildSearchButton(),
              const SizedBox(height: 16),
              if (result.isNotEmpty) _buildResultText(),
              const Text(
                'Users List:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              isLoading ? const Center(child: CircularProgressIndicator()) : _buildUsersList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarOperationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OperationButton(
          label: 'Add Car',
          onPressed: () {
            Dialogs.showAddCarDialog(
              context: context,
              carManager: carManager,
              onResult: (success, message) {
                if (success) {
                  _loadAllData();
                  searchController.clear();
                  _showAwesomeSnackbar('Success', message, ContentType.success);
                } else {
                  _showAwesomeSnackbar('Error', message, ContentType.failure);
                }
              },
            );
          },
        ),
        OperationButton(
          label: 'Update Car',
          onPressed: () => Dialogs.showUpdateCarDialog(
            context: context,
            carManager: carManager,
            onSuccess: () {
              _loadAllData();
              _showAwesomeSnackbar('Success', 'Car updated!', ContentType.success);
            },
          ),
        ),
        OperationButton(
          label: 'Delete Car',
          onPressed: () => Dialogs.showDeleteCarDialog(
            context: context,
            carManager: carManager,
            onSuccess: () {
              _loadAllData();
              _showAwesomeSnackbar('Success', 'Car deleted!', ContentType.success);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPartOperationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OperationButton(
          label: 'Add Part',
          onPressed: () {
            Dialogs.showAddPartDialog(
              context: context,
              partManager: partManager,
              onResult: (success, message) {
                if (success) {
                  _loadAllData();
                  searchController.clear();
                  _showAwesomeSnackbar('Success', message, ContentType.success);
                } else {
                  _showAwesomeSnackbar('Error', message, ContentType.failure);
                }
              },
            );
          },
        ),
        OperationButton(
          label: 'Update Part',
          onPressed: () => Dialogs.showUpdatePartDialog(
            context: context,
            partManager: partManager,
            onSuccess: () {
              _loadAllData();
              _showAwesomeSnackbar('Success', 'Part updated!', ContentType.success);
            },
          ),
        ),
        OperationButton(
          label: 'Delete Part',
          onPressed: () => Dialogs.showDeletePartDialog(
            context: context,
            partManager: partManager,
            onSuccess: () {
              _loadAllData();
              _showAwesomeSnackbar('Success', 'Part deleted!', ContentType.success);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserOperationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OperationButton(
          label: 'Delete User',
          onPressed: () => Dialogs.showDeleteUserDialog(
            context: context,
            userTable: userTable,
            onSuccess: () {
              _loadAllData();
              _showAwesomeSnackbar('Success', 'User deleted!', ContentType.success);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return SearchField(
      controller: searchController,
      onChanged: (_) => _filterItems(),
    );
  }

  Widget _buildSearchButton() {
    return SearchButton(
      carManager: carManager,
      partManager: partManager,
      userTable: userTable,
      searchController: searchController,
      parentContext: context,
      searchType: _selectedTabIndex == 0
          ? SearchType.car
          : _selectedTabIndex == 1
          ? SearchType.part
          : SearchType.user,
      onResult: (msg, type) {
        setState(() {
          result = msg;
        });
        _showAwesomeSnackbar(
          type == ContentType.success
              ? 'Success'
              : (type == ContentType.warning ? 'Not Found' : 'Error'),
          msg,
          type,
        );
      },
    );
  }

  Widget _buildResultText() {
    return ResultText(result: result);
  }

  Widget _buildCarsList() {
    return filteredCars.isEmpty
        ? const Text('No cars found', style: TextStyle(color: Colors.white70))
        : ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredCars.length,
      itemBuilder: (context, index) {
        final car = filteredCars[index];
        return Card(
          color: Colors.indigo.withOpacity(0.85),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                car.imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/placeholder.jpeg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              car.modelName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Price: ${car.price} USD',
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Text(
              'ID: ${car.id}',
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () => _showProductActionDialog(context, car),
          ),
        );
      },
    );
  }

  Widget _buildPartsList() {
    return filteredParts.isEmpty
        ? const Text('No parts found', style: TextStyle(color: Colors.white70))
        : ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredParts.length,
      itemBuilder: (context, index) {
        final part = filteredParts[index];
        return Card(
          color: Colors.indigo.withOpacity(0.85),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                part.imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/placeholder.jpeg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              part.partName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Price: ${part.price} USD',
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Text(
              'ID: ${part.id}',
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () => _showProductActionDialog(context, part),
          ),
        );
      },
    );
  }

  Widget _buildUsersList() {
    return filteredUsers.isEmpty
        ? const Text('No users found', style: TextStyle(color: Colors.white70))
        : ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return Card(
          color: Colors.indigo.withOpacity(0.85),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: user.profilePicPath != null
                  ? Image.asset(
                user.profilePicPath!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/placeholder.jpeg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
                  : Image.asset(
                'assets/images/placeholder.jpeg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              user.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Email: ${user.email}',
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Text(
              'ID: ${user.id}',
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () => Dialogs.showDeleteUserDialog(
              context: context,
              userTable: userTable,
              onSuccess: () {
                _loadAllData();
                _showAwesomeSnackbar('Success', 'User deleted!', ContentType.success);
              },
            ),
          ),
        );
      },
    );
  }
}