<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

class UsersController extends Controller
{
    public function index()
    {
        $users = User::all();
        return response()->json($users);
    }

    public function show($id)
    {
        $user = User::find($id);
        if ($user) {
            return response()->json($user);
        } else {
            return response()->json(['error' => 'User not found.'], 404);
        }
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required',
            'email' => 'required',
            'password' => 'required|min:6'
        ]);

        $user = User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => bcrypt($data['password'])
        ]);
        if ($user) {
            return response()->json([
                'message' => 'Success.',
                'data' => $user
            ]);
        } else {
            return response()->json([
                'message' => 'Error.'
            ]);
        }
    }

    public function update(Request $request)
    {
        $data = $request->validate([
            'id' => 'required|integer|min:1',
            'name' => 'required',
            'email' => 'required',
            'password' => 'required|min:6'
        ]);

        $user = User::where('id', '=', $data['id'])->first();

        if ($user) {
            $old_data = $user->replicated();

            $user->name = $data['name'];
            $user->email = $data['email'];
            $user->password = bcrypt($data['password']);
            if ($user->save()) {
                $object = [
                    'response' => 'success',
                    "old" => $old_data,
                    "new" => $user
                ];
                return response()->json($object);
            } else {
                $object = [
                    "response" => "Error"
                ];
                return response()->json($object, 500);
            }
        } else {
            return response()->json(['error' => 'User not found.'], 404);
        }
    }

    public function destroy($id)
    {
        $user = User::find($id);
        if ($user) {
            $user->delete();
            return response()->json(['message' => 'User deleted successfully.']);
        } else {
            return response()->json(['error' => 'User not found.'], 404);
        }
    }
    
    public function getUsers($name){
        $users = User::where('name', 'like', "%$name%")->get();
        $response = [];
        foreach ($users as $user) {
            $object = [
                "id" => $user->id,
                "Nombre" => $user->name,
                "Email" => $user->email
            ];
            $response[] = $object;
        }
        return response()->json($response);
    }
}