package co.nilin.opex.port.wallet.postgres.dao

import co.nilin.opex.port.wallet.postgres.model.CurrencyModel
import co.nilin.opex.port.wallet.postgres.model.CurrencyRateModel
import kotlinx.coroutines.flow.Flow
import org.springframework.data.domain.Pageable
import org.springframework.data.r2dbc.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.data.repository.reactive.ReactiveCrudRepository
import org.springframework.stereotype.Repository
import reactor.core.publisher.Mono

@Repository
interface CurrencyRepository: ReactiveCrudRepository<CurrencyModel, String> {

}