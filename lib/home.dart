import 'dart:collection';

import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import "package:uuid/uuid.dart";
class BreadCrumb{
 late bool isActive;
 late final String name;
 late final String uuid;
 BreadCrumb({required this.isActive,required this.name}): uuid = const Uuid().v4();

 void activate(){
   isActive = true;
 }

 @override
  bool operator == (covariant BreadCrumb other) =>
    uuid == other.uuid;

  @override
  // TODO: implement hashCode
  int get hashCode => uuid.hashCode;

  String get title => name + (isActive ? " > " : " ");
}

class BreadCrumbProvider extends ChangeNotifier{
  final List<BreadCrumb> _items =[];
  UnmodifiableListView<BreadCrumb> get item => UnmodifiableListView(_items);

  void add(BreadCrumb breadCrumb){
    for(final item in _items){
      item.activate();
    }
    _items.add(breadCrumb);
    notifyListeners();
  }

  void reset(){
    _items.clear();
    notifyListeners();
  }
}

class BreadCrumbWidget extends StatelessWidget {
  final UnmodifiableListView<BreadCrumb> breadCrumbs;

  const BreadCrumbWidget({Key? key, required this.breadCrumbs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: breadCrumbs.map((breadCrumb){
          return Text(
            breadCrumb.title,
            style: TextStyle(
              color: breadCrumb.isActive? Colors.blue : Colors.black
            ),
          );
        }).toList()
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Column(
        children:[
          Consumer<BreadCrumbProvider>(builder: (context, value, child){
            return BreadCrumbWidget(breadCrumbs: value.item);
          }),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamed("/new");
          }, child: const Text("Add new Bread Crumb")
          ),

          TextButton(
              onPressed: (){
                context.read<BreadCrumbProvider>().reset();
              },
              child: const Text("Reset")
          )
        ],
      ),
    );
  }
}
class NewBreadCrumbWidget extends StatefulWidget {
  const NewBreadCrumbWidget({Key? key}) : super(key: key);

  @override
  State<NewBreadCrumbWidget> createState() => _NewBreadCrumbWidgetState();
}

class _NewBreadCrumbWidgetState extends State<NewBreadCrumbWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
_controller = TextEditingController();
super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a New Bread Crumb"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Enter a new bread crumb here ..."
            ),
          ),
          TextButton(onPressed: (){
            final text = _controller.text;
            if (text.isNotEmpty) {
              final breadCrumb = BreadCrumb(isActive: false, name: text);
              context.read<BreadCrumbProvider>().add(breadCrumb);
            }
            Navigator.of(context).pop();

          },
              child: const Text("Add"))
        ],
      ),
    );
  }
}
