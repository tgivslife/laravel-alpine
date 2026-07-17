<?php

use App\Jobs\TestJob;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Schedule;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

// scheduler test: heartbeat every minute, visible in the container logs
Schedule::call(fn () => Log::info('Scheduler heartbeat'))->everyMinute()->name('test-heartbeat');

// horizon test: the scheduler pushes a queued job every minute
Schedule::job(new TestJob('scheduler'))->everyMinute();
