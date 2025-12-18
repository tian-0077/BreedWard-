import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text("About", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/edgar.png'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Column(
              children: [
                Text('John Edgar S. Anthony'),
                Text('Adviser', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 90,
                  width: 90,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/whar.png'),
                  ),
                ),
                SizedBox(
                  height: 90,
                  width: 90,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/jess.png'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text('Wharren Cayetano'), Text('Jessie Dadula')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'BS.CpE Student',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'BS.CpE Student',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
        
            SizedBox(height: 30),
            SizedBox(
              height: 90,
              width: 90,
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/pijay.png'),
              ),
            ),
            SizedBox(height: 5,),
            Text('Pijay Montano'),
            Text('BS.CpE Student',style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
