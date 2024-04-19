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

    public function update(Request $request, $perfilId)
    {
        try {
            $perfil = User::findOrFail($perfilId);

            $validatedData = $request->validate([
                'name' => 'nullable|max:55',
                'email' => 'nullable',

            ]);

            $updated = false;

            if ($request->filled('name')) {
                $perfil->name = $validatedData['name'];
                $updated = true;
            }

            if ($request->filled('email')) {
                $perfil->email = $validatedData['email'];
                $updated = true;
            }



            if ($updated) {
                $perfil->save();
            }

            return response()->json([
                'message' => $updated ? 'Perfil actualizado correctamente' : 'No se realizaron cambios',
                'profile' => $perfil,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Se produjo un error al procesar la solicitud: ' . $e->getMessage(),
            ], 500);
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