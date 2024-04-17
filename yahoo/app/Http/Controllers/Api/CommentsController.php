<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Comment;
use Illuminate\Http\Request;

class CommentsController extends Controller
{
    public function index()
    {
        $comments = Comment::all();
        return response()->json($comments);
    }

    public function show($id)
    {
        $comment = Comment::find($id);
        if ($comment) {
            return response()->json($comment);
        } else {
            return response()->json(['error' => 'Comment not found.'], 404);
        }
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'answer_id' => 'required|exists:answers,id',
            'comment' => 'required'
        ]);
        $comment = Comment::create([
            'answer_id' => $data['answer_id'],
            'comment' => $data['comment']
        ]);
        return response()->json($comment, 201);
    }

    public function update(Request $request, $_id)
    {
        $data = $request->validate([
            'comment' => 'required'
        ]);

        $comment = Comment::find($_id);

        if (!$comment) {
            return response()->json(['error' => 'Comment not found.'], 404);
        }

        $comment->comment = $data['comment'];
        $comment->save();

        return response()->json($comment);
    }

    public function destroy($__id)
    {
        $comment = Comment::find($__id);
        if ($comment) {
            $comment->delete();
            return response()->json(['message' => 'Comment deleted successfully.']);
        } else {
            return response()->json(['error' => 'Comment not found.'], 404);
        }
    }
}
