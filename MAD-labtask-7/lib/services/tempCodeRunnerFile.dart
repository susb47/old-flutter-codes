
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/note.dart';

class FirebaseService {

  static final FirebaseService _instance = FirebaseService._internal();
  
  factory FirebaseService() {
    return _instance;
  }
  
  FirebaseService._internal();
  
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection reference for notes
  late final CollectionReference _notesCollection;
  
  // Network status
  bool _isOnline = true;
  bool get isOnline => _isOnline;
  
  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    _instance._notesCollection = _instance._firestore.collection('notes');
    
    // Set up connectivity listener
    Connectivity().onConnectivityChanged.listen((result) {
      _instance._isOnline = result != ConnectivityResult.none;
    });
    
    // Check initial connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    _instance._isOnline = connectivityResult != ConnectivityResult.none;
  }
  
  // Get notes stream
  Stream<List<Note>> getNotesStream() {
    return _notesCollection
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Note(
          id: doc.id,
          title: data['title'] ?? '',
          content: data['content'] ?? '',
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }
  
  // Add a new note
  Future<Note?> addNote(String title, String content) async {
    if (!_isOnline) {
      throw NetworkException('No internet connection');
    }
    
    try {
      final now = DateTime.now();
      
      final docRef = await _notesCollection.add({
        'title': title,
        'content': content,
        'createdAt': now,
        'updatedAt': now,
      });
      
      return Note(
        id: docRef.id,
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
      );
    } catch (e) {
      throw FirestoreException('Failed to add note: ${e.toString()}');
    }
  }
  
  // Update an existing note
  Future<Note?> updateNote(String id, String title, String content) async {
    if (!_isOnline) {
      throw NetworkException('No internet connection');
    }
    
    try {
      final now = DateTime.now();
      
      await _notesCollection.doc(id).update({
        'title': title,
        'content': content,
        'updatedAt': now,
      });
      
      // Get the note's creation date
      final docSnapshot = await _notesCollection.doc(id).get();
      final data = docSnapshot.data() as Map<String, dynamic>;
      final createdAt = (data['createdAt'] as Timestamp).toDate();
      
      return Note(
        id: id,
        title: title,
        content: content,
        createdAt: createdAt,
        updatedAt: now,
      );
    } catch (e) {
      throw FirestoreException('Failed to update note: ${e.toString()}');
    }
  }
  
  // Delete a note
  Future<void> deleteNote(String id) async {
    if (!_isOnline) {
      throw NetworkException('No internet connection');
    }
    
    try {
      await _notesCollection.doc(id).delete();
    } catch (e) {
      throw FirestoreException('Failed to delete note: ${e.toString()}');
    }
  }
  
  // Get a single note
  Future<Note?> getNote(String id) async {
    if (!_isOnline) {
      throw NetworkException('No internet connection');
    }
    
    try {
      final docSnapshot = await _notesCollection.doc(id).get();
      
      if (!docSnapshot.exists) {
        return null;
      }
      
      final data = docSnapshot.data() as Map<String, dynamic>;
      
      return Note(
        id: docSnapshot.id,
        title: data['title'] ?? '',
        content: data['content'] ?? '',
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      );
    } catch (e) {
      throw FirestoreException('Failed to get note: ${e.toString()}');
    }
  }
  
  
  void toggleNetworkStatus() {
    
  }
}

class FirestoreException implements Exception {
  final String message;
  FirestoreException(this.message);
  
  @override
  String toString() => 'FirestoreException: $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}