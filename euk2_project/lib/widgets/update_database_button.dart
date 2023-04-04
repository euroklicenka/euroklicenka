import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Big red button that updates the database.
Widget databaseButton({required BuildContext context}) {
  return ElevatedButton.icon(
    onPressed: () => context.read<LocationManagementBloc>().add(OnLoadLocationsFromDatabase()),
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white70,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    icon: const Icon(Icons.refresh),
    label: const Text('Aktualizace databáze'),
  );
}

///Disabled version of Database Button.
Widget databaseButtonDisabled({required AnimationController animController}) {
  return OutlinedButton.icon(
    onPressed: null,
    style: ElevatedButton.styleFrom(
      disabledForegroundColor: Colors.black87,
      minimumSize: const Size.fromHeight(47.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    icon: RotationTransition(
      turns: animController,
      child: const Icon(Icons.refresh),
    ),
    label: const Text('Aktualizace databáze'),
  );
}

///Green variant of the disabled update database, that tells the user
///the update was successful.
Widget databaseButtonFinished() {
  return ElevatedButton.icon(
    onPressed: null,
    style: ElevatedButton.styleFrom(
      disabledForegroundColor: Colors.white70,
      disabledBackgroundColor: Colors.green,
      minimumSize: const Size.fromHeight(62),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    icon: const Icon(Icons.check),
    label: const Text('Aktualizace dokončena'),
  );
}
