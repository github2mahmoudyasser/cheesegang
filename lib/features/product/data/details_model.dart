



    class DetailsModel {
    final int id;
    final String name;
    final String image;

      DetailsModel({
       required this.id,
        required this.name,
        required this.image
    });
      factory DetailsModel.fromJson(Map<String,dynamic>json){
        String imageUrl = json["image"];
        if(imageUrl.startsWith("http://")){
          imageUrl =  imageUrl.replaceFirst("http://", "https://");
        }
        return DetailsModel(
            id: json["id"],
            name: json["name"],
          image: imageUrl
         
        );
      }

    }



