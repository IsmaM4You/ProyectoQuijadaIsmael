<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Question extends Model
{
    protected $fillable = [
        'question',
        'category_id'
    ];

    public function category()
    {
        return $this->belongsTo(Category::class, "category_id");
    }

    public function answers()
    {
        return $this->hasMany(Answer::class);
    }
}
