import moment from 'moment'
import orderBy from 'lodash/orderBy'
const typeOf = o => Object.prototype.toString.call(o).slice(8, -1).toLowerCase() // Cuttet den return String zusammen von [Object BLA]
const purify = o => JSON.parse(JSON.stringify(o)) // purify data

/**
 * mockData - simulate Ajax request and respond
 * @param   {Object} query input
 * @param   {Object} _cur the currency for that the table gets created
 * @param   {Object} _statePublicKeys publicKey Object from state
 * @resolve {Object}
 */
export default function mockKey (query, _cur, _statePublicKeys) {
  let rows = []
  console.log(query)
  console.log(_cur)
  for (let i = 0; i < _statePublicKeys.currency.length; i++) {
    if (_statePublicKeys.currency[i].cur === _cur) {
      for (let j = 0; j < _statePublicKeys.currency[i].key.length; j++) {
        rows.push({
          'name': _statePublicKeys.currency[i].name[j],
          'key': _statePublicKeys.currency[i].key[j],
          'isDefault': _statePublicKeys.currency[i].isDefault[j]
        })
      }
    }
  }

  query = purify(query)

  const { limit = 10, offset = 0, sort = '', order = '' } = query

  // custom query conditions
  const customQueryConditions = ['key', 'name', 'isDefault']

  // query[field] wird mit jeder customQueryConditions übeprüft
  //
  customQueryConditions.forEach(field => {
    switch (typeOf(query[field])) {
      case 'array':
        rows = rows.filter(row => query[field].includes(row[field]))
        break
      case 'string':
        rows = rows.filter(row => row[field].toLowerCase().includes(query[field].toLowerCase()))
        break
      default:
        // nothing to do
        break
    }
  })

  if (sort) {
    rows = orderBy(rows, sort, order)
  }

  const res = {
    rows: rows.slice(offset, offset + limit),
    total: rows.length
  }

  const consoleGroupName = 'Mock data - ' + moment().format('YYYY-MM-DD HH:mm:ss')
  setTimeout(() => {
    console.group(consoleGroupName)
    console.info('Receive:', query)
    console.info('Respond:', res)
    console.groupEnd(consoleGroupName)
  }, 0)
  return Promise.resolve(purify(res))
}
