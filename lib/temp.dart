//TODO: listview builder taken from homestatefullwidget
// ListView.builder(
// itemCount: snapshot.data.docs.length,
// itemBuilder: (context, index) {
// DocumentSnapshot data = snapshot.data.docs[index];
// Map getDocs = data.data();
// print(snapshot.data.docs[index]["title"]);
// return Container(
// child: CustomListItemTwo(
// thumbnail: Container(
// decoration: const BoxDecoration(color: Colors.orange),
// ),
// title: snapshot.data.docs[index]["title"],
// subtitle: snapshot.data.docs[index]['Description'],
// author: snapshot.data.docs[index]['Author'],
// publishDate: snapshot.data.docs[index]['DatePosted'],
// ),
// );
// },
// );
