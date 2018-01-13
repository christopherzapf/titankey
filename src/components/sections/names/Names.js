import contract from 'truffle-contract'
import TitanKey from '../../../build/contracts/Titankey.json'
import { APPROVED_NETWORK_ID, NETWORKS } from '../../util/constants'

let names = null
class Names {
  constructor () {
    names = names || this
    return names
  }

  insertNewName (state = null, data = {}) {
    return new Promise((resolve, reject) => {
      this.accessTitanKeyContractWith({
        state,
        method: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.insertNewName(data.titanName, Date.now(), { from: coinbase })
            .then((result) => {
              // Successful Sign-up
              resolve(data)
            })
            .catch((e) => {
              reject(e)
            })
          })
        }
      })
      .then((result) => {
        console.log(result)
        resolve(result)
      })
      .catch((err) => {
        reject(err)
      })
    })
  }

  getNamesOfUser (state = null) {
    return new Promise((resolve, reject) => {
      this.accessTitanKeyContractWith({
        state,
        method: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getNamesOfUser({from: coinbase})
            .then((result) => {
              // Successful Fetch
              resolve(this.getUTF8NamesOfUser(state, result))
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

  getUTF8NamesOfUser (state, results) {
    const utf8Results = results.map(result => state.web3.instance().toUtf8(result))
    return utf8Results
  }

  isNameAvailable (state = null, data = {}) {
    return new Promise((resolve, reject) => {
      this.accessTitanKeyContractWith({
        state,
        method: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getNamesOfUser(data.titanName, {from: coinbase})
            .then((result) => {
              // Successful Fetch
              resolve(result)
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

  getUTF8UserData (state, results) {
    console.log(2)
    console.log(results)
    const utf8Results = results.map(result => state.web3.instance().toUtf8(result))
    console.log(utf8Results)
    return {
      firstName: utf8Results[0],
      lastName: utf8Results[1],
      email: utf8Results[2]
    }
  }
}

export default new Auth()
