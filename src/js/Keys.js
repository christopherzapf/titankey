import contract from 'truffle-contract'
import TitanKey from '../../build/contracts/Titankey.json'
import { APPROVED_NETWORK_ID, NETWORKS } from '../util/constants'

let keys = null
class Keys {
  constructor () {
    keys = keys || this
    return keys
  }

  addPublicKeyToUser (state = null, data = {}) {
    return new Promise((resolve, reject) => {
      this.accessTitanKeyContractWith({
        state,
        method: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.addPublicKeyToUser(data.key, data.name, data.currency, data.isDefault, { from: coinbase })
            .then((result) => {
              // Successful Sign-up
              console.log(data.key, data.name, data.currency, data.isDefault)
              console.log('Keys.js > addPublicKeyToUser')
              resolve(data)
            })
            .catch((e) => {
              reject(e)
            })
          })
        }
      })
      .then((result) => {
        resolve(result)
      })
      .catch((err) => {
        reject(err)
      })
    })
  }

  getPublicKeys (state = null) {
    return new Promise((resolve, reject) => {
      this.accessTitanKeyContractWith({
        state,
        method: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getPublicKeys({from: coinbase})
            .then((result) => {
              // Successful Fetch
              console.log('Keys.js > getPublicKeys')
              resolve(this.getPublicKeysUTF8(state, result))
            })
            .catch((e) => {
              reject(e)
            })
          })
        }
      })
      .then((result) => {
        resolve(result)
      })
      .catch((err) => {
        reject(err)
      })
    })
  }

  getPublicKeysUTF8 (state, results) {
    console.log('Keys.js > getPublicKeysUTF8')

    let publicKeys = results[0]
    let currencies = results[1]
    let names = results[2]
    let isDefault = results[3]

    publicKeys = publicKeys.map(result => state.web3.instance().toUtf8(result))
    currencies = currencies.map(result => state.web3.instance().toUtf8(result))
    names = names.map(result => state.web3.instance().toUtf8(result))

    console.log(publicKeys)

    return {
      key: publicKeys,
      name: names,
      currency: currencies,
      isDefault: isDefault
    }
  }

  /* getCurFromUser (state = null) {
    return new Promise((resolve, reject) => {
      this.accessTitanKeyContractWith({
        state,
        method: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getCurFromUser({from: coinbase})
            .then((result) => {
              // Successful Fetch
              console.log('getCurFromUser:')
              console.log(result)
              resolve(
                this.getUTF8UserCurrencies(state, result)
              )
            })
            .catch((e) => {
              reject(e)
            })
          })
        }
      })
      .then((result) => {
        resolve(result)
      })
      .catch((err) => {
        reject(err)
      })
    })
  }

  getUTF8UserCurrencies (state, results) {
    // map ruft für jeden Wert des Arrays die übergebene Funktion auf
    // Arrowfunctions: result (function params), => (return wert)
    const utf8Results = results.map(result => state.web3.instance().toUtf8(result))
    return {
      key: utf8Results[0],
      name: utf8Results[1],
      currency: utf8Results[2],
      isDefault: utf8Results[3]
    }
  }
*/

  accessTitanKeyContractWith (dataObject = {}) {
    const state = dataObject.state
    return new Promise(function (resolve, reject) {
      if (!state || !state.web3 || !(state.web3.instance)) {
        reject('Web3 is not initialised. Use a Web3 injector')
      } else {
        if (state.web3.networkId === APPROVED_NETWORK_ID) {
          let titanKeyInstance = contract(TitanKey)
          titanKeyInstance.setProvider(state.web3.instance().currentProvider)
          state.web3.instance().eth.getCoinbase((err, coinbase) => {
            if (err) {
              console.error(':::Unable to get coinbase for this operation')
              reject(err)
            } else {
              titanKeyInstance.deployed()
              .then((contractInstance) => {
                dataObject.method(contractInstance, coinbase)
                .then((result) => {
                  resolve(result)
                })
                .catch((err) => {
                  reject(err)
                })
              })
              .catch((err) => {
                reject(err)
              })
            }
          })
        } else {
          reject(`You are NOT connected to the ${NETWORKS[APPROVED_NETWORK_ID]} on which this dApp runs.`)
        }
      }
    })
  }
}

export default new Keys()
