<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

class AuthController extends Controller
{
    // AuthController.php

public function login(Request $request)
{
    $loginData = $request->validate([
        'email' => 'required|email',
        'password' => 'required'
    ]);

    // Verifica las credenciales
    if (Auth::attempt($loginData)) {
        // Si las credenciales son válidas, genera el token de acceso
        $accessToken = auth()->user()->createToken('authToken')->accessToken;

        // Retorna la respuesta con el usuario autenticado y el token de acceso
        return response()->json([
            'user' => auth()->user(),
            'access_token' => $accessToken
        ]);
    } else {
        // Si las credenciales no son válidas, devuelve un mensaje de error
        return response()->json([
            'message' => 'Credenciales inválidas'
        ], 401);
    }
}


    public function register(Request $request)
    {
        $validatedData = $request->validate([
            'name' => 'required',
            'email' => 'required|email|unique:users',
            'password' => 'required|confirmed'
        ]);

        $validatedData['password'] = bcrypt($request->password);
        $user = User::create($validatedData);
        $accessToken = $user->createToken('authToken')->accessToken;

        return response(['user' => $user, 'access_token' => $accessToken]);
    }
}