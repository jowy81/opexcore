package co.nilin.opex.port.bcgateway.postgres.dao

import co.nilin.opex.port.bcgateway.postgres.model.ChainAddressTypeModel
import org.springframework.data.repository.reactive.ReactiveCrudRepository

interface ChainAddressTypeRepository : ReactiveCrudRepository<ChainAddressTypeModel, Long> {

}