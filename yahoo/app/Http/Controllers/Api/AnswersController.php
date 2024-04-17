<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Answer;
use Illuminate\Http\Request;

class AnswersController extends Controller
{
    public function list()
    {
        $answers = Answer::all();
        return response()->json($answers);
    }

    public function getById($id)
    {
        $answer = Answer::find($id);
        if ($answer) {
            return response()->json($answer);
        } else {
            return response()->json(['error' => 'Answer not found.'], 404);
        }
    }

    public function create(Request $request)
    {
        $data = $request->validate([
            'question_id' => 'required|exists:questions,id',
            'answer' => 'required'
        ]);
        $answer = Answer::create([
            'question_id' => $data['question_id'],
            'answer' => $data['answer']
        ]);
        return response()->json($answer, 201);
    }

    public function update(Request $request, $_id)
    {
        $data = $request->validate([
            'answer' => 'required'
        ]);

        $answer = Answer::find($_id);

        if (!$answer) {
            return response()->json(['error' => 'Answer not found.'], 404);
        }

        $answer->answer = $data['answer'];
        $answer->save();

        return response()->json($answer);
    }

    public function destroy($__id)
    {
        $answer = Answer::find($__id);
        if ($answer) {
            $answer->delete();
            return response()->json(['message' => 'Answer deleted successfully.']);
        } else {
            return response()->json(['error' => 'Answer not found.'], 404);
        }
    }
    public function getByQuestionId($question_id)
{
    $answers = Answer::where('question_id', $question_id)->get();
    return response()->json($answers);
}

}
