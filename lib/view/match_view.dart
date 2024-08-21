import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MatchView extends StatefulWidget {
  const MatchView({super.key});

  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  _MatchViewState() {
    _selectedVal = _classItemList[0];
    _selectEnemyVal = _enemyItemList[0];
    _selectResult = _resultList[0];
  }

  List<String> _matchArray = [];
  List<String> _enemyArray = [];
  List<String> _resultArray = [];

  int _winCount = 0;
  int _lossCount = 0;

  Future<void> getData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _matchArray = prefs.getStringList("_matchArray") ?? [];
      _enemyArray = prefs.getStringList("_enemyArray") ?? [];
      _resultArray = prefs.getStringList("_resultArray") ?? [];

      updateWinLossCount(); // Aktualisiere die Zählung basierend auf gespeicherten Daten

      setState(() {});
    } catch (e) {
      print("Error while loading the data $e");
    }
  }

  Future<void> saveData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList("_matchArray", _matchArray);
      await prefs.setStringList("_enemyArray", _enemyArray);
      await prefs.setStringList("_resultArray", _resultArray);
      updateWinLossCount(); // Aktualisiere die Zählung nach dem Speichern neuer Daten
      await reloadList();
    } catch (e) {
      print("Error while saving data $e");
    }
  }

  Future<void> reloadList() async {
    await getData();
    setState(() {});
  }

  Future<void> deleteData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _matchArray.clear();
        _enemyArray.clear();
        _resultArray.clear();
        _winCount = 0; // Setze die Zählung der Siege zurück
        _lossCount = 0; // Setze die Zählung der Niederlagen zurück
      });
      await prefs.clear();
    } catch (e) {
      print("Error while deleting data $e");
    }
  }

  void clearMatches() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Matches"),
            content: const Text("Do you want to delete all Matches?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.redAccent),
                  )),
              TextButton(
                  onPressed: () {
                    deleteData();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Delete")),
            ],
          );
        });
  }

  void addItemToList() {
    setState(() {
      _matchArray.add(_selectedVal!);
      _enemyArray.add(_selectEnemyVal!);
      _resultArray.add(_selectResult!);
      if (_selectResult == "Win") {
        _winCount++; // Zähle einen Sieg hinzu
      } else if (_selectResult == "Loss") {
        _lossCount++; // Zähle eine Niederlage hinzu
      }
    });
  }

  Color? checkResul(String data) {
    if (data == "Win") {
      return Colors.green;
    } else if (data == "Loss") {
      return Colors.red;
    } else {
      return Colors.transparent;
    }
  }

  void updateWinLossCount() {
    _winCount = _resultArray
        .where((result) => result == "Win")
        .length;
    _lossCount = _resultArray
        .where((result) => result == "Loss")
        .length;
  }

  String? _selectedVal = "Warrior";
  String? _selectEnemyVal = "Warrior";
  String? _selectResult = "Select";
  final String key = "dataListKey";
  String now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

  final List<dynamic> _classItemList = [
    "Warrior",
    "Druid",
    "Rouge",
    "Mage",
    "DemonHunter",
    "DeathKnight",
    "Hunter",
    "Shaman",
    "Priest",
    "Warlock",
    "Paladin"
  ];
  final List<dynamic> _enemyItemList = [
    "Warrior",
    "Druid",
    "Rouge",
    "Mage",
    "DemonHunter",
    "DeathKnight",
    "Hunter",
    "Shaman",
    "Priest",
    "Warlock",
    "Paladin"
  ];
  final List<dynamic> _resultList = ["Win", "Loss"];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F2E3E),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<dynamic>(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25))),
              backgroundColor: Colors.white,
              isDismissible: true,
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height - 350.0,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 90),
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 200.0,
                            child: DropdownButton(
                                iconEnabledColor: Colors.blue,
                                iconDisabledColor: Colors.red,
                                value: _selectedVal,
                                items: _classItemList.map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedVal = val as String;
                                  });
                                }),
                          ),
                          const SizedBox(height: 10),
                          const Text("Your Class"),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 200.0,
                              child: DropdownButton(
                                  value: _selectEnemyVal,
                                  items: _enemyItemList.map((i) {
                                    return DropdownMenuItem(
                                      value: i,
                                      child: Text(i),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectEnemyVal = val as String;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text("Enemy Class"),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 200.0,
                              child: DropdownButton(
                                  value: _selectResult
                                  ,
                                  items: _resultList.map((r) {
                                    return DropdownMenuItem(
                                      value: r,
                                      child: Text(r),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectResult = val as String;
                                    });
                                  }),
                            ),
                          ),
                          const Text("Result"),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue),
                              child: TextButton(
                                onPressed: () async {
                                  addItemToList();
                                  await saveData();
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              });
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        elevation: 10,
        backgroundColor: const Color(0xFF3F2E3E),
        title: Text(
          "Matches  W: $_winCount - L: $_lossCount",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white54),
        ),
        actions: [
          IconButton(
            onPressed: () {
              clearMatches();
            },
            icon: const Icon(Icons.delete),
            tooltip: "Delete all Matches",
            color: Colors.grey,
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _matchArray.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 3);
        },
        itemBuilder: (BuildContext context, int index) {
          final String data = _resultArray[index];
          return Material(
            elevation: 3,
            child: Container(
              decoration: BoxDecoration(
                color: checkResul(data),
              ),
              child: ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _matchArray[index],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_enemyArray[index],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        Text(
                          DateFormat("MM-dd-yyyy / hh:mm")
                              .format(DateTime.now()),
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
