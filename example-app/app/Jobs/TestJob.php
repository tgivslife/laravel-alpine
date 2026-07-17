<?php

namespace App\Jobs;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Log;

class TestJob implements ShouldQueue
{
    use Queueable;

    public function __construct(public string $source) {}

    public function handle(): void
    {
        Log::info("TestJob processed by horizon (source: {$this->source})");
    }
}
