import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_record_address/provider/auth_provider.dart';
import 'package:school_record_address/widget/home_page.dart';



enum FilterOption {
  Favorite,
  All,
}
var _showFavoriteOnly = false;
class PopMenu extends StatefulWidget {
  const PopMenu({super.key});

  @override
  State<PopMenu> createState() => _PopMenuState();
}

class _PopMenuState extends State<PopMenu> {
  @override
  Widget build(BuildContext context) {
    return  PopupMenuButton(
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.Favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(),));
                },
                  child: Text('Home'), value: FilterOption.Favorite),
              PopupMenuItem(
                onTap: (){
                  Provider.of<Auth>(context, listen: false).logout();
                },
                child: Text('LogOut'), value: FilterOption.All),
            ],
          );
  }
}