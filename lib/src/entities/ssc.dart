class  Ssc
{
  String title;
  String imgpath;
  String description;
  String date_in;
  String date_out;
  int fines;
  Ssc(this.title,this.imgpath,this.description,this.date_in,this.date_out);

  Ssc.fromJson(Map<String, dynamic> json){
    title = json['title'];
    imgpath=json['imgpath'];
    description=json['description'];
    date_in=json['date_in'];
    date_out=json['date_out'];
    fines=json['fines'];
  }
}