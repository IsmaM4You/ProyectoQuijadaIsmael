<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Question;
use Illuminate\Http\Request;

class QuestionsController extends Controller
{
    public function list()
    {
        $questions = Question::all();
        return response()->json($questions);
    }

    public function getById($id)
    {
        $questions = Question::where('category_id', '=', $id)->get();
        $response = [];
        foreach ($questions as $question){
            $object = [
                "id" => $question->id,
                "question" => $question->question,
                "category_id" => $question->category_id
            ];
            $response[] = $object;
        }
        return response()->json($response);
    }
    
    public function create(Request $request)
    {
        $data = $request->validate([
            'question' => 'required',
            'category_id' => 'required' // Agrega esta validación para asegurarte de que se proporcione category_id
        ]);
        $question = Question::create([
            'question' => $data['question'],
            'category_id' => $data['category_id'] // Asegúrate de asignar category_id
        ]);
        return response()->json($question, 201);
    }
    
    public function update(Request $request, $_id)
    {
        $data = $request->validate([
            'question' => 'required'
        ]);

        $question = Question::find($_id);

        if (!$question) {
            return response()->json(['error' => 'Question not found.'], 404);
        }

        $question->question = $data['question'];
        $question->save();

        return response()->json($question);
    }

    public function destroy($__id)
    {
        $question = Question::find($__id);
        if ($question) {
            $question->delete();
            return response()->json(['message' => 'Question deleted successfully.']);
        } else {
            return response()->json(['error' => 'Question not found.'], 404);
        }
    }

    
}
