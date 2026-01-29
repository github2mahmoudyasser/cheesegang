


// دا كلاس هنوحد فية شكل الرسالة اللي هتيجي من السيرفر هتيجي علي شكل مسدج عشان هنستخدمة في Dio exceptions

//Encapsulation :collect message data
//Single Responsibility // one job for this class
//Polymorphism // print String مفهومة
//O - Open/Closed Principle //open to add

class ApiError{
       final String message;
       final int? statusCode;

    ApiError({required this.message
      ,this.statusCode});

    @override
     String toString() {
        return message;
  }
     }





















