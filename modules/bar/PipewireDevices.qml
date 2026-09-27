import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs.modules.components
import qs.utils

Loader {
    active: Pipewire.ready
    sourceComponent: Component {
        Row {
            spacing: 6

            PwObjectTracker {
                objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
            }

            Row {
                spacing: 4

                Icon {
                    text: {
                        if (Pipewire.defaultAudioSink.audio.muted) {
                            return "";
                        }

                        const volume = Pipewire.defaultAudioSink.audio.volume;
                        if (volume >= 0.7) {
                            return "";
                        }
                        if (volume >= 0.1) {
                            return "";
                        }

                        return "";
                    }
                }

                Text {
                    text: Pipewire.defaultAudioSink.audio.muted ? "" : Percentage.toPercentage(Pipewire.defaultAudioSink.audio.volume)
                    color: "white"
                }
            }

            Row {
                spacing: 4

                Icon {
                    text: {
                        if (Pipewire.defaultAudioSource.audio.muted) {
                            return "";
                        }
                        return "";
                    }
                }

                Text {
                    text: Pipewire.defaultAudioSource.audio.muted ? "" : Percentage.toPercentage(Pipewire.defaultAudioSource.audio.volume)
                    color: "white"
                }
            }
        }
    }
}
