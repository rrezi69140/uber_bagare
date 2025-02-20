import 'package:flutter/material.dart';
import 'package:uber_bagare/Pages/home.dart';

class FighterPage extends StatelessWidget {
  const FighterPage({Key? key, required this.user}) : super(key: key);
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${user['name']['first']} ${user['name']['last']}     "),
      ),
      body: Center(
        child: Column(
          spacing: 150,
          children: [
            Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage("${user['picture']['large']}"),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 15,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            "${user['dob']['age'] / 2.toInt()} victoire  ${user['dob']['age'] % 2.toInt()} defaite  ${user['dob']['age'] / 10.toInt()} KO"),
                        Text("Accepte tout typppe de combat mm 2v2 ")
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Compétence : ")],
              ),
              Row(
                children: [],
              )
            ])
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shadowColor: Color.fromARGB(255, 0, 0, 0),
        color: const Color.fromARGB(255, 252, 252, 252),
        child: Center(
          child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Home();
                }));
              },
              child: const Text('Go Back')),
        ),
      ),
    );
  }
}
