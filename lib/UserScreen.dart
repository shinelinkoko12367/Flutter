import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_bloc_crud/Model/UserModel.dart';
import 'package:map_bloc_crud/bloc/User/data_bloc.dart';
import 'package:map_bloc_crud/bloc/User/data_event.dart';
import 'package:map_bloc_crud/bloc/User/data_state.dart';
import 'package:map_bloc_crud/map_screen.dart';

class UserPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map & BLoC CRUD ',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
              icon: Icon(Icons.map)),
          IconButton(
              onPressed: () {
                // Show the dialog for creating new data
                _showDialog(context, null);
              },
              icon: Icon(Icons.add))
        ],
        centerTitle: true,
      ),
      body: BlocBuilder<DataBloc, DataState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DataLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            state.data[index].title
                                .toString(), // Assuming 'title' is the title
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'ID: ${state.data[index].id}\nDesc: ${state.data[index].desc}', // Displaying ID and description
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  // Populate the controllers with the existing data for editing
                                  nameController.text =
                                      state.data[index].title.toString();
                                  descController.text =
                                      state.data[index].desc.toString();

                                  // Show the dialog for updating data
                                  _showDialog(context, state.data[index]);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  context.read<DataBloc>().add(DeleteData(
                                      state.data[index].id.toString()));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          if (state is DataCreated) {
            nameController.clear();
            descController.clear();
            context.read<DataBloc>().add(FetchData());
            return _buildStateMessage(
              icon: Icons.check_circle,
              message: 'Data Created: ${state.data}',
              color: Colors.green,
            );
          } else if (state is DataUpdated) {
            context.read<DataBloc>().add(FetchData());
            return _buildStateMessage(
              icon: Icons.update,
              message: 'Data Updated: ${state.data}',
              color: Colors.orange,
            );
          } else if (state is DataDeleted) {
            context.read<DataBloc>().add(FetchData());
            return _buildStateMessage(
              icon: Icons.delete,
              message: 'Data Deleted',
              color: Colors.red,
            );
          } else if (state is DataError) {
            return _buildStateMessage(
              icon: Icons.error,
              message: state.message,
              color: Colors.redAccent,
            );
          }
          return _buildStateMessage(
            icon: Icons.info_outline,
            message: 'No Data',
            color: Colors.grey,
          );
        },
      ),
    );
  }

  Widget _buildStateMessage({
    required IconData icon,
    required String message,
    required Color color,
  }) {
    return Center(
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show the dialog for both creating and updating data
  void _showDialog(BuildContext context, User? data) {
    // If data is null, it's for creating new data, otherwise for updating
    if (data != null) {
      nameController.text = data.title ?? "";
      descController.text = data.desc ?? "";
    } else {
      // nameController.clear();
      // descController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data == null ? 'Create Data' : 'Update Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Enter Title'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Enter Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Create or update data depending on whether `data` is null
                final updatedData = {
                  'title': nameController.text,
                  'desc': descController.text,
                };
                log(data.toString());
                log(updatedData.toString());
                if (data == null) {
                  // Create new data
                  context.read<DataBloc>().add(
                        CreateData(User.fromJson(updatedData)),
                      );
                } else {
                  // Update existing data
                  context.read<DataBloc>().add(
                        UpdateData(
                            data.id.toString(), User.fromJson(updatedData)),
                      );
                }
                Navigator.pop(context); // Close the dialog
              },
              child: Text(data == null ? 'Create' : 'Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Close the dialog without doing anything
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
