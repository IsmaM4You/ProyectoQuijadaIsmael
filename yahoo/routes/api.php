<?php


use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\CategoriesController;
use App\Http\Controllers\Api\CommentsController;
use App\Http\Controllers\Api\QuestionsController;
use App\Http\Controllers\Api\AnswersController;
use App\Http\Controllers\Api\UsersController;
use App\Http\Controllers\Api\AuthController;


Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});


Route::get('/categories/list', [CategoriesController::class, 'list']); 
Route::get('/categories/{id}', [CategoriesController::class, 'getById']); 
Route::post('/categories', [CategoriesController::class, 'create']); 
Route::put('/categories/{_id}', [CategoriesController::class, 'update']); 


Route::get('/comments', [CommentsController::class, 'index']); 
Route::get('/comments/{id}', [CommentsController::class, 'show']); 
Route::post('/comments/create', [CommentsController::class, 'store']); 
Route::put('/comments/{_id}', [CommentsController::class, 'update']); 
Route::delete('/comments/{__id}', [CommentsController::class, 'destroy']); 


Route::get('/questions/list', [QuestionsController::class, 'list']); 
Route::get('/questions/{id}', [QuestionsController::class, 'getById']); 
Route::post('/questions', [QuestionsController::class, 'create']); 
Route::put('/questions/{_id}', [QuestionsController::class, 'update']); 
Route::delete('/questions/{__id}', [QuestionsController::class, 'destroy']); 


Route::get('/answers/list', [AnswersController::class, 'list']); 
Route::get('/answers/{id}', [AnswersController::class, 'getById']); 
Route::post('/answers', [AnswersController::class, 'create']); 
Route::put('/answers/{_id}', [AnswersController::class, 'update']); 
Route::delete('/answers/{__id}', [AnswersController::class, 'destroy']);
Route::get('/answers/question/{question_id}', [AnswersController::class, 'getByQuestionId']);


Route::get('/users', [UsersController::class, 'index']); 
Route::get('/users/{id}', [UsersController::class, 'show']); 
Route::post('/users', [UsersController::class, 'store']); 
Route::post('/users/update', [UsersController::class, 'update']); 
Route::delete('/users/{id}', [UsersController::class, 'destroy']); 
Route::get('/users/search/{name}', [UsersController::class, 'getUsers']); 


Route::post('login', [AuthController::class, 'login']);
Route::post('register', [AuthController::class, 'register']);
    