package co.nilin.opex.port.eventlog.kafka.spi

import co.nilin.opex.matching.core.eventh.events.CoreEvent

interface EventListener {
    fun id(): String
    fun onEvent(coreEvent: CoreEvent, partition: Int, offset: Long, timestamp: Long)
}