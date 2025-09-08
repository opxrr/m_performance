import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:m_performance/admin/admin_custom_widgets/car_dialogs.dart';
import 'package:m_performance/database/carsData.dart';
import 'admin_custom_widgets/operation_button.dart';
import 'admin_custom_widgets/result_text.dart';
import 'admin_custom_widgets/search_button.dart';
import 'admin_custom_widgets/search_field.dart';
import 'car_manager.dart';

class AdminPanel extends StatefulWidget {
  static const String routeName = 'adminPanel';

  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final CarManager carManager = CarManager();
  final TextEditingController searchModelController = TextEditingController();
  List<CarProject> cars = [];
  List<CarProject> filteredCars = [];
  String result = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCars();
    // Listen to search input changes for real-time filtering
    searchModelController.addListener(_filterCars);
  }

  @override
  void dispose() {
    searchModelController.removeListener(_filterCars);
    searchModelController.dispose();
    carManager.dispose();
    super.dispose();
  }

  void _loadCars() async {
    setState(() {
      isLoading = true;
    });
    try {
      final loadedCars = await carManager.getAllCars();
      setState(() {
        cars = loadedCars;
        filteredCars = loadedCars;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        result = 'Error loading cars: $e';
        isLoading = false;
      });
      _showAwesomeSnackbar(
        'Error',
        'Error loading cars: $e',
        ContentType.failure,
      );
    }
  }

  void _filterCars() {
    final query = searchModelController.text.toLowerCase();
    setState(() {
      filteredCars = cars
          .where((car) => car.modelName.toLowerCase().contains(query))
          .toList();
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
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      MediaQuery.of(context).size.width *
                      0.04, // Responsive padding
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildOperationButtons(),
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
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildCarsList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OperationButton(
          label: 'Add car',
          onPressed: () {
            CarDialogs.showAddCarDialog(
              context,
              carManager: carManager,
              onResult: (success, message) {
                if (success) {
                  _loadCars();
                  searchModelController.clear();
                  _showAwesomeSnackbar('Success', message, ContentType.success);
                } else {
                  _showAwesomeSnackbar('Error', message, ContentType.failure);
                }
              },
            );
          },
        ),
        OperationButton(
          label: 'Update car',
          onPressed: () => CarDialogs.showUpdateCarDialog(
            context,
            carManager: carManager,
            onSuccess: () {
              _loadCars();
              _showAwesomeSnackbar(
                'Success',
                'Car updated!',
                ContentType.success,
              );
            },
          ),
        ),
        OperationButton(
          label: 'Delete car',
          onPressed: () => CarDialogs.showDeleteCarDialog(
            context,
            carManager: carManager,
            onSuccess: () {
              _loadCars();
              _showAwesomeSnackbar(
                'Success',
                'Car deleted!',
                ContentType.success,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return SearchField(
      controller: searchModelController,
      onChanged: (_) => _filterCars(),
    );
  }

  Widget _buildSearchButton() {
    return SearchButton(
      carManager: carManager,
      searchController: searchModelController,
      parentContext: context,
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
                        'assets/images/placeholder.jpeg', // Placeholder image
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
                    'Price: ${car.price}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    'ID: ${car.id}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => CarDialogs.showUpdateCarDialog(
                    context,
                    carManager: carManager,
                    car: car,
                    onSuccess: () {
                      _loadCars();
                      _showAwesomeSnackbar(
                        'Success',
                        'Car updated!',
                        ContentType.success,
                      );
                    },
                  ),
                ),
              );
            },
          );
  }
}
