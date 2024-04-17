<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    protected $fillable = ['category']; 
    
    
    public function questions()
    {
        return $this->belongsTo(Question::class, 'category_id');
    }

    public function comments()
    {
        return $this->hasManyThrough(Comment::class, Question::class);
    }
}
