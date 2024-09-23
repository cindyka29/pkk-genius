<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table("iurans",function(Blueprint $table){
            $table->double("nominal")->default(0)->after("activity_id");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table("iurans",function(Blueprint $table){
            $table->dropColumn('nominal');
        });
    }
};
