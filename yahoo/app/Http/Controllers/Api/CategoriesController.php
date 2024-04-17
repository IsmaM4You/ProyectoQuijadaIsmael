<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;

class CategoriesController extends Controller
{
    public function list()
    {
        $categories_ = Category::all();
        $list = [];

        foreach ($categories_ as $category) {
            $object = [
                "id" => $category->id,
                "type" => $category->category // Se cambió "type" por "category" para reflejar el nombre correcto del campo en la base de datos
            ];
            array_push($list, $object);
        }
        return response()->json($list);
    }

    public function getById($id)
    {
        $categories = Category::where('id', '=', $id)->get();
        $response = [];
        foreach ($categories as $category){
            $object = [
                "id" => $category->id,
                "category" => $category->category
            ];
            $response[] = $object;
        }
        return response()->json($response);
    }
    
    

    public function create(Request $request)
    {
        $data = $request->validate([
            'type' => 'required|min:4' // Se cambió "type" por "category" para reflejar el nombre correcto del campo en la base de datos
        ]);
        $category = Category::create([
            'category' => $data['type'] // Se cambió "type" por "category" para reflejar el nombre correcto del campo en la base de datos
        ]);
        if ($category) {
            $object = [
                "response" => 'Success. Category created',
                'data' => $category
            ];
            return response()->json($object, 201); // Se cambió el código de respuesta a 201 para indicar que la categoría fue creada exitosamente
        } else {
            $object = [
                "response" => 'Error. Unable to create category'
            ];
            return response()->json($object, 500); // Se cambió el código de respuesta a 500 para indicar un error interno del servidor
        }
    }

    public function update(Request $request, $_id)
    {
        $data = $request->validate([
            'type' => 'required|min:4' // Se cambió "type" por "category" para reflejar el nombre correcto del campo en la base de datos
        ]);

        $category = Category::find($_id); // Se cambió "where" por "find" para buscar por ID de forma más eficiente

        if ($category) {
            $old_data = $category->replicate();

            $category->category = $data['type']; // Se cambió "type" por "category" para reflejar el nombre correcto del campo en la base de datos
            if ($category->save()) {
                $object = [
                    "response" => 'Success. Category updated',
                    "old" => $old_data,
                    "new" => $category
                ];
                return response()->json($object);
            } else {
                $object = [
                    "response" => 'Error. Unable to update category'
                ];
                return response()->json($object, 500); // Se cambió el código de respuesta a 500 para indicar un error interno del servidor
            }
        } else {
            $object = [
                "response" => 'Error. Category not found.'
            ];
            return response()->json($object, 404); // Se cambió el código de respuesta a 404 para indicar que la categoría no fue encontrada
        }
    }
}
