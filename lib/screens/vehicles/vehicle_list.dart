import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/vehicle.dart';
import 'vehicle_details.dart';

class VehicleListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fundo preto
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Meus Veículos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Vehicle>>(
          stream: DatabaseService().getVehicles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.white));
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro ao carregar veículos: ${snapshot.error}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Nenhum veículo cadastrado.',
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),
              );
            }

            List<Vehicle> vehicles = snapshot.data!;
            return ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                Vehicle vehicle = vehicles[index];
                return Card(
                  color: Colors.grey[900], // Fundo escuro para o cartão
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      vehicle.name,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      '${vehicle.model} - ${vehicle.year}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VehicleDetailsPage(vehicle: vehicle)),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
