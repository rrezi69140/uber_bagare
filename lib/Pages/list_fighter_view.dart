import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'fighter_profile.dart';

class ListFighterView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListFighterViewState();
}

class ListFighterViewState extends State<ListFighterView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetFighterProfile(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Please wait, it\'s loading...'));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: veuillez contacter le support'));
        } else {
          var fighters = snapshot.data ?? [];

          return Scaffold(
            appBar: AppBar(title: Text("Fighters List")),
            body: ListView.builder(
              itemCount: fighters.length,
              itemBuilder: (context, index) {
                var fighter = fighters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return FighterPage(user: fighter);
                        }),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        CircleAvatar(
                          backgroundImage: NetworkImage(fighter['avatar_url'] ?? ''),
                          radius: 30,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nom: ${fighter['first_name']} ${fighter['last_name']}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${fighter['victory'] ?? 0} victoires - "
                                  "${fighter['defeat'] ?? 0} défaites - "
                                  "${fighter['ko'] ?? 0} KO",
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          "${(fighter['latitude'] ?? 0).toStringAsFixed(2)} km",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
