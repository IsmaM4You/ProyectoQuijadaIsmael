<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    protected $fillable = ['answer_id', 'comment']; // Campos llenables
    
    public function answer()
    {
        return $this->belongsTo(Answer::class);
    }
}
