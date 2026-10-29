<?php

declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

use PHPUnit\Framework\TestCase;

class InstallScannerTest extends TestCase
{
    public function testInstance(): void
    {
        $actual = file_exists(__DIR__ . '/../src/InstallScanner');
        static::assertTrue($actual);
    }
}
