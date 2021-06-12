import 'package:flutter/material.dart';
import 'search_page.dart';


class SearchPageCardListView extends StatelessWidget {
  static const routeName = '/SearchPageCardListView';

  @override
  Widget build(BuildContext context) {
    final SearchData data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Card(
              color: Color(0xD2FFFFFF),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Text(
                              "Word:  ",
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)
                          ),
                          Text(
                              data.wordResult,
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                  color: Colors.black)
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: SizedBox()),
                    Expanded(
                      flex: 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Pronunciation:  ',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)
                          ),
                          Container(
                            height: 25,
                            child: ListView.builder(
                                scrollDirection:Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: data.pronunciation.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return PronunciationWidget(data: data, index: index);
                                }
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 13,
            child: Container(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: data.definition.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return CardWidget(data: data, index: index);
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key key,
    @required this.data,
    @required this.index,
  }) : super(key: key);

  final SearchData data;
  final int index;


  @override
  Widget build(BuildContext context) {

    return Container(
      color: Color(0xD2FFFFFF),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:15.0),
            child: Container(
              height: 50,
              child: Row(
                children: [
                  Text(
                      "Class:  ",
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)
                  ),
                  Text(
                      data.partOfSpeech[index],
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black)
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 10,
            thickness: 5,
            indent: 20,
            endIndent: 20,
            color: Colors.grey,
          ),
          ListTile(
              leading: null,
              title: Text(
                  "Meaning:  ",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)
              ),
              subtitle: Text(
                  data.definition[index],
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black)
              ),
              onTap: () {

              }
          ),
          data.examples[index] == 'no example' ?
              Container() :
          ListTile(
              leading: null,
              title: Text(
                  "Example :  ",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)
              ),
              subtitle: Text(
                  data.examples[index],
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black)
              ),
              onTap: () {

              }
          ),
          SizedBox(height: 5,)


        ],
      ),
      // added padding
    );
  }
}

class PronunciationWidget extends StatelessWidget {
  const PronunciationWidget({
    Key key,
    @required this.data,
    @required this.index,

  }) : super(key: key);

  final SearchData data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
              '[' + data.pronunciationKeys[index] ,
      style: TextStyle(
                  fontSize: 25.0,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black)
          ),
          Text(
              ': ' + data.pronunciation[index] + ']' + ', ',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  color: Colors.black)
          ),
          // SizedBox(width: 10,)
        ],
      ),
    );
  }
}