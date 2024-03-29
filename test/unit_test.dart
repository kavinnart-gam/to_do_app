import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/services/task_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  test('fetchTasks with status todo should return a TaskResponse for successful calls', () async {
    final mockDio = MockDio();
    final taskService = TaskService(dio: mockDio);

    // Mock the Dio response
    final responseData = {
      "tasks": [
        {
          "id": "cbb0732a-c9ab-4855-b66f-786cd41a3cd1",
          "title": "Read a book",
          "description": "Spend an hour reading a book for pleasure",
          "createdAt": "2023-03-24T19:30:00Z",
          "status": "TODO"
        },
        {
          "id": "119a8c45-3f3d-41da-88bb-423c5367b81a",
          "title": "Exercise",
          "description": "Go for a run or do a workout at home",
          "createdAt": "2023-03-25T09:00:00Z",
          "status": "TODO"
        },
        {
          "id": "ab7e3eb3-058d-44de-bb97-01b35d2b2c29",
          "title": "Pay bills",
          "description": "Pay monthly bills and schedule future payments",
          "createdAt": "2023-03-25T14:00:00Z",
          "status": "TODO"
        },
        {
          "id": "67cbf4e4-c81e-4c8e-aa1e-6efc7e75b0a8",
          "title": "Write a letter",
          "description": "Write a letter to a family member or friend",
          "createdAt": "2023-03-27T15:45:00Z",
          "status": "TODO"
        },
        {
          "id": "c59ca7e3-d158-4f9a-b4db-618926a4f5d5",
          "title": "Clean the kitchen",
          "description": "Clean the countertops, sink, and stovetop",
          "createdAt": "2023-03-28T12:30:00Z",
          "status": "TODO"
        },
        {
          "id": "8992a148-74db-49de-877a-691be7cb9c9f",
          "title": "Try a new recipe",
          "description": "Find a new recipe to try for dinner",
          "createdAt": "2023-03-28T18:00:00Z",
          "status": "TODO"
        },
        {
          "id": "09eaa2d7-c9b9-429e-94fb-8426b68df6e1",
          "title": "Call a friend",
          "description": "Catch up with a friend over the phone",
          "createdAt": "2023-03-30T16:15:00Z",
          "status": "TODO"
        },
        {
          "id": "1b9c0030-6c96-4d1b-9c63-1d8ec7b49fa6",
          "title": "Take a walk",
          "description": "Go for a walk outside and enjoy the fresh air",
          "createdAt": "2023-03-31T11:45:00Z",
          "status": "TODO"
        },
        {
          "id": "b36c4603-3d22-4f06-8e70-04af4b4c4f79",
          "title": "Organize bookshelf",
          "description": "Sort books by genre and alphabetize",
          "createdAt": "2023-04-01T10:30:00Z",
          "status": "TODO"
        },
        {
          "id": "1cb357aa-78e9-46a3-a012-46250b1a15b7",
          "title": "Do laundry",
          "description": "Wash and fold clothes that have piled up",
          "createdAt": "2023-04-01T13:00:00Z",
          "status": "TODO"
        },
        {
          "id": "3a1d202c-991e-416f-8d2b-90956dc26c9a",
          "title": "Plan next vacation",
          "description": "Research and plan a trip to a new destination",
          "createdAt": "2023-04-01T14:00:00Z",
          "status": "TODO"
        },
        {
          "id": "f09a0b32-f2b2-4611-b01a-9b66bb81983e",
          "title": "Clean car",
          "description": "Wash and vacuum car interior",
          "createdAt": "2023-04-01T16:45:00Z",
          "status": "TODO"
        },
        {
          "id": "e45ebce2-1611-4bc2-a14f-200fbb8035b5",
          "title": "Learn a new skill",
          "description": "Start learning a new programming language or tool",
          "createdAt": "2023-04-04T09:15:00Z",
          "status": "TODO"
        },
        {
          "id": "129b2049-6325-46b5-b7c5-c5ba8f7cfae5",
          "title": "Buy a gift",
          "description": "Find a suitable present for cousin's wedding",
          "createdAt": "2023-04-07T11:00:00Z",
          "status": "TODO"
        },
        {
          "id": "3b84dd6e-21cf-4b77-9b91-1b6d7c6f9362",
          "title": "Schedule doctor appointment",
          "description": "Make an appointment for annual check-up",
          "createdAt": "2023-04-07T15:30:00Z",
          "status": "TODO"
        },
        {
          "id": "b0af9de9-7e16-4296-a99d-167d95d50131",
          "title": "Plan birthday party",
          "description": "Organize a celebration for friend's upcoming birthday",
          "createdAt": "2023-04-10T14:30:00Z",
          "status": "TODO"
        },
        {
          "id": "a341b369-51aa-4382-a2c2-6a08b2a95625",
          "title": "Apply for job",
          "description": "Submit application and resume for a new job opening",
          "createdAt": "2023-04-10T14:30:00Z",
          "status": "TODO"
        },
        {
          "id": "adab4b8e-2742-4af7-98cc-293a4c4a2239",
          "title": "Renew passport",
          "description": "Submit application and pay fee to renew passport",
          "createdAt": "2023-04-11T09:00:00Z",
          "status": "TODO"
        },
        {
          "id": "6ec3f6b3-6b67-4268-ba9e-9d7c03fa206f",
          "title": "Organize closet",
          "description": "Sort through clothes and donate items that are no longer needed",
          "createdAt": "2023-04-12T16:15:00Z",
          "status": "TODO"
        },
        {
          "id": "ab38b50c-38c6-49e9-8517-2bfb00cf41d6",
          "title": "Buy new shoes",
          "description": "Purchase a new pair of running shoes",
          "createdAt": "2023-04-14T10:30:00Z",
          "status": "TODO"
        }
      ],
      "pageNumber": 1,
      "totalPages": 2
    };
    final response = Response(
      statusCode: 200,
      data: responseData,
      requestOptions: RequestOptions(path: 'https://todo-list-api-mfchjooefq-as.a.run.app/todo-list?'),
    );

    // Call the fetchTasks method
    final taskResponse = await taskService.fetchTasks(status: 'TODO', limit: 20, offset: 0);

    // Verify the response
    expect(taskResponse, isA<TaskResponse>());
    expect(taskResponse.tasks!.length, equals(20));
    expect(taskResponse.tasks!.last.id, equals("ab38b50c-38c6-49e9-8517-2bfb00cf41d6"));
    expect(taskResponse.tasks!.last.status, equals("TODO"));
  });

  test('fetchTasks with status doing should return a TaskResponse for successful calls', () async {
    final mockDio = MockDio();
    final taskService = TaskService(dio: mockDio);

    // Mock the Dio response
    final responseData = {
      "tasks": [
        {
          "id": "cbb0732a-c9ab-4855-b66f-786cd41a3cd1",
          "title": "Do not go where the path may lead, go instead where there is no path and leave a trail.",
          "description": "Ralph Waldo Emerson",
          "createdAt": "2023-03-25T19:30:00Z",
          "status": "DOING"
        },
        {
          "id": "2e6908c7-bdb1-4bf7-a108-f10bb53c13d9",
          "title": "The best way to predict the future is to invent it.",
          "description": "Alan Kay",
          "createdAt": "2023-04-02T10:30:00Z",
          "status": "DOING"
        },
        {
          "id": "e49e71a8-7e38-45a3-96a3-02de8d7c9e9b",
          "title": "Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle.",
          "description": "Christian D. Larson",
          "createdAt": "2023-04-05T09:00:00Z",
          "status": "DOING"
        },
        {
          "id": "3dc3e1ab-1057-4a1c-a836-5f5ec4c4fa4f",
          "title": "If you want to achieve greatness, stop asking for permission.",
          "description": "Unknown",
          "createdAt": "2023-04-05T15:45:00Z",
          "status": "DOING"
        },
        {
          "id": "5e6faea6-2fc2-43fc-8d5c-ef5cf5b65a51",
          "title": "Plan vacation",
          "description": "Research destinations and compare prices for flights and hotels",
          "createdAt": "2023-04-14T10:30:00Z",
          "status": "DOING"
        },
        {
          "id": "155d2a21-d013-4a6d-87cb-22c8aa0a6c75",
          "title": "The only way to do great work is to love what you do.",
          "description": "Steve Jobs",
          "createdAt": "2023-04-18T11:30:00Z",
          "status": "DOING"
        },
        {
          "id": "dfca7b4d-4c4e-4aa2-aa1b-9beab17c1d16",
          "title": "Success is not final, failure is not fatal: it is the courage to continue that counts.",
          "description": "Winston Churchill",
          "createdAt": "2023-04-18T18:15:00Z",
          "status": "DOING"
        },
        {
          "id": "2b6f08cf-f3e4-4ed4-85eb-f015a4271f4d",
          "title": "I have not failed. I’ve just found 10,000 ways that won’t work.",
          "description": "Thomas Edison",
          "createdAt": "2023-04-19T14:45:00Z",
          "status": "DOING"
        },
        {
          "id": "c03e139d-3221-42cc-8ea1-5de04b5a5f60",
          "title": "If you’re not making mistakes, then you’re not making decisions.",
          "description": "Catherine Cook",
          "createdAt": "2023-04-20T08:00:00Z",
          "status": "DOING"
        },
        {
          "id": "edfc96d1-9b8a-4c27-96d2-aa6c556b2a2f",
          "title": "Do not go where the path may lead, go instead where there is no path and leave a trail.",
          "description": "Ralph Waldo Emerson",
          "createdAt": "2023-04-21T19:15:00Z",
          "status": "DOING"
        }
      ],
      "pageNumber": 1,
      "totalPages": 1
    };
    final response = Response(
      statusCode: 200,
      data: responseData,
      requestOptions: RequestOptions(path: 'https://todo-list-api-mfchjooefq-as.a.run.app/todo-list?'),
    );

    // Call the fetchTasks method
    final taskResponse = await taskService.fetchTasks(status: 'DOING', limit: 20, offset: 0);

    // Verify the response
    expect(taskResponse, isA<TaskResponse>());
    expect(taskResponse.tasks!.length, equals(10));
    expect(taskResponse.tasks!.last.id, equals("edfc96d1-9b8a-4c27-96d2-aa6c556b2a2f"));
    expect(taskResponse.tasks!.last.status, equals("DOING"));
  });

  test('fetchTasks with status done should return a TaskResponse for successful calls', () async {
    final mockDio = MockDio();
    final taskService = TaskService(dio: mockDio);

    // Mock the Dio response
    final responseData = {
      "tasks": [
        {
          "id": "9dd9316f-39d2-4ef1-bfc6-45df0b847881",
          "title": "Levitating - Dua Lipa ft. DaBaby",
          "description":
              "I got you moonlight, you're my starlight / I need you all night, come on, dance with me / I'm levitating / You, moonlight, you're my starlight / I need you all night, come on, dance with me / I'm levitating",
          "createdAt": "2022-04-03T15:34:20.000Z",
          "status": "DONE"
        },
        {
          "id": "42af0e5a-9bfe-49fc-a42d-7175c5b5a5a7",
          "title": "Circles - Post Malone",
          "description":
              "We couldn't turn around / 'Til we were upside down / I'll be the bad guy now / But know I ain't too proud / I couldn't be there / Even when I try / You don't believe it / We do this every time",
          "createdAt": "2022-04-03T15:34:20.000Z",
          "status": "DONE"
        },
        {
          "id": "0453129a-7f4e-4b4c-9c80-988d7f67b1f3",
          "title": "Save Your Tears - The Weeknd & Ariana Grande",
          "description":
              "I saw you dancing in a crowded room\nYou look so happy when I'm not with you\nBut then you saw me, caught you by surprise\nA single teardrop falling from your eye",
          "createdAt": "2023-03-24T12:32:10Z",
          "status": "DONE"
        },
        {
          "id": "6bfc2816-1de6-4132-8eb2-2a50a89a9f7d",
          "title": "Peaches - Justin Bieber ft. Daniel Caesar, Giveon",
          "description":
              "I got my peaches out in Georgia (Oh, yeah, shit)\nI get my weed from California (That's that shit)\nI took my chick up to the North, yeah (Badass bitch)\nI get my light right from the source, yeah (Yeah, that's it)",
          "createdAt": "2023-03-24T12:45:29Z",
          "status": "DONE"
        },
        {
          "id": "18199df2-f64e-4a5d-9b64-c6a3a6f44452",
          "title": "drivers license - Olivia Rodrigo",
          "description":
              "'Cause you said forever, now I drive alone past your street\nAnd all my friends are tired of hearing how much I miss you, but\nI kinda feel sorry for them 'cause they'll never know you the way that I do, yeah",
          "createdAt": "2023-04-01T14:45:00Z",
          "status": "DONE"
        },
        {
          "id": "1bf6a47a-8d84-4f29-a804-c91de40a1638",
          "title": "Afterglow - Ed Sheeran",
          "description":
              "Stop the clocks, it's amazing \nYou should see the way the light dances off your hair \nA million colours of hazel, golden and red \nSaturday morning is fading \nThe sun's reflected by the coffee in your hand \nMy eyes are caught in your gaze all over again \nWe were love drunk waiting on a miracle \nTrying to find ourselves in the winter snow \nSo alone in love like the world had disappeared \nOh I won't be silent and I won't let go \nI will hold on tighter 'til the afterglow",
          "createdAt": "2023-04-03T12:45:37.652Z",
          "status": "DONE"
        },
        {
          "id": "63e7ebc9-8de8-4dfe-81c2-7f844d96fada",
          "title": "Willow - Taylor Swift",
          "description":
              "Life was a willow and it bent right to your wind \nHead on the pillow, I could feel you sneaking in \nAs if you were a mythical thing \nLike you were a trophy or a champion ring \nThere was one prize I'd cheat to win \nThe rain came pouring down \nWhen I was drowning, that's when I could finally breathe \nAnd by morning, gone was any trace of you \nI think I am finally clean",
          "createdAt": "2023-04-08T12:45:37.653Z",
          "status": "DONE"
        },
        {
          "id": "d46b231a-4081-4c63-a6a2-7db8fb0a52a7",
          "title": "Call Mom",
          "description": "Catch up with Mom and see how she's doing",
          "createdAt": "2023-04-17T12:00:00Z",
          "status": "DONE"
        }
      ],
      "pageNumber": 1,
      "totalPages": 1
    };
    final response = Response(
      statusCode: 200,
      data: responseData,
      requestOptions: RequestOptions(path: 'https://todo-list-api-mfchjooefq-as.a.run.app/todo-list?'),
    );

    // Call the fetchTasks method
    final taskResponse = await taskService.fetchTasks(status: 'DONE', limit: 20, offset: 0);

    // Verify the response
    expect(taskResponse, isA<TaskResponse>());
    expect(taskResponse.tasks!.length, equals(8));
    expect(taskResponse.tasks!.last.id, equals("d46b231a-4081-4c63-a6a2-7db8fb0a52a7"));
    expect(taskResponse.tasks!.last.status, equals("DONE"));
  });
}
