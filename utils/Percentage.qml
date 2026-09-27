pragma Singleton

import QtQuick
import Quickshell

Singleton {
    function toPercentage(num: double): string {
      return `${Math.round(num * 100)}%`;
    }
}
