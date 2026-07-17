<?php

use App\Jobs\TestJob;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return Inertia::render('Welcome');
})->name('home');

// postgres test: proves pdo_pgsql connectivity and that the migrations ran
Route::get('test-db', function () {
    return response()->json([
        'driver' => DB::connection()->getDriverName(),
        'database' => DB::connection()->getDatabaseName(),
        'migrations' => DB::table('migrations')->count(),
        'sessions' => DB::table('sessions')->count(),
    ]);
})->name('test-db');

// horizon test: dispatch a queued job on demand
Route::get('test-job', function () {
    TestJob::dispatch('http');

    return response()->json(['status' => 'TestJob dispatched']);
})->name('test-job');

Route::get('dashboard', function () {
    return Inertia::render('Dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

require __DIR__.'/settings.php';
require __DIR__.'/auth.php';
