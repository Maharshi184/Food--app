import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  FilterScreen({super.key,required this.currentFilters});

  final Map<filters,bool> currentFilters;

  @override
  State<StatefulWidget> createState() {
    return _FilterScreen();
  }
}

enum filters { glutenfree, lactosfree, vegan, vegetarian }

class _FilterScreen extends State<FilterScreen> {
  var _glutenFreeFilter = false;
  var _lectosFreeFilter = false;
  var _vegan = false;
  var _vegetarian = false;

  @override
  void initState() {
    super.initState();
    _glutenFreeFilter = widget.currentFilters[filters.glutenfree]!;
    _lectosFreeFilter = widget.currentFilters[filters.lactosfree]!;
    _vegan = widget.currentFilters[filters.vegan]!;
    _vegetarian = widget.currentFilters[filters.vegetarian]!;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop({
          filters.glutenfree: _glutenFreeFilter,
          filters.lactosfree: _lectosFreeFilter,
          filters.vegan: _vegan,
          filters.vegetarian: _vegetarian,
        });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('your filters'),
        ),
        body: Column(
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.only(left: 34, right: 22),
              value: _glutenFreeFilter,
              onChanged: (isChecked) {
                setState(() {
                  _glutenFreeFilter = isChecked;
                });
              },
              title: const Text(
                'Gluten free',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text('only items that are gluten free',
                  style: TextStyle(color: Colors.white)),
              activeColor: Colors.blue,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.only(left: 34, right: 22),
              value: _lectosFreeFilter,
              onChanged: (isChecked) {
                setState(() {
                  _lectosFreeFilter = isChecked;
                });
              },
              title: const Text(
                ' Lectos free',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text('only items that are lectos free',
                  style: TextStyle(color: Colors.white)),
              activeColor: Colors.blue,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.only(left: 34, right: 22),
              value: _vegan,
              onChanged: (isChecked) {
                setState(() {
                  _vegan = isChecked;
                });
              },
              title: const Text(
                'Vegan',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text('only items that are Vegan',
                  style: TextStyle(color: Colors.white)),
              activeColor: Colors.blue,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.only(left: 34, right: 22),
              value: _vegetarian,
              onChanged: (isChecked) {
                setState(() {
                  _vegetarian = isChecked;
                });
              },
              title: const Text(
                'Vegetarian',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text('items that are Vegetarian',
                  style: TextStyle(color: Colors.white)),
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
