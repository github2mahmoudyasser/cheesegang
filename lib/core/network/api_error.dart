


// دا كلاس هنوحد فية شكل الرسالة اللي هتيجي من السيرفر هتيجي علي شكل مسدج عشان هنستخدمة في Dio exceptions


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





















