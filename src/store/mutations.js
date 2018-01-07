import { MUTATION_TYPES, APPROVED_NETWORK_ID } from '../util/constants'

function resetUser (state, web3Status = {}) {
  const user = {
    firstName: '',
    lastName: '',
    email: '',
    isLoggedIn: false
  }

  const userCopy = state.user
  Object.assign(userCopy, user, web3Status)
  state.user = userCopy
}

function resetPublicKeys (state, web3Status = {}) {
  state.publicKey.currency = []
  state.user.hasKeys = false
}

export default {
  [MUTATION_TYPES.REGISTER_WEB3_INSTANCE] (state, payload) {
    const result = payload.result

    const web3Copy = state.web3
    web3Copy.instance = () => result.web3
    web3Copy.address = result.address
    web3Copy.coinbase = result.coinbase
    web3Copy.networkId = result.networkId
    web3Copy.error = result.web3Error
    web3Copy.isInjected = result.hasInjectedWeb3

    state.web3 = web3Copy

    if (payload.callback) payload.callback(state)
  },
  [MUTATION_TYPES.UPDATE_USER_BLOCKCHAIN_STATUS] (state) {
    const hasWeb3InjectedBrowser = state.web3.isInjected
    const hasCoinbase = !!(state.web3.coinbase && state.web3.coinbase !== '')
    const isConnectedToApprovedNetwork = !!(state.web3.networkId && state.web3.networkId !== '' && state.web3.networkId === APPROVED_NETWORK_ID)
    const web3Status = {
      coinbase: state.web3.coinbase,
      hasWeb3InjectedBrowser,
      hasCoinbase,
      isConnectedToApprovedNetwork
    }

    if (hasWeb3InjectedBrowser && hasCoinbase && isConnectedToApprovedNetwork) {
      const userCopy = state.user
      Object.assign(userCopy, web3Status)
      state.user = userCopy
    } else {
      resetUser(state, web3Status)
    }
  },
  [MUTATION_TYPES.UPDATE_WEB3_PROPERTIES] (state, payload) {
    for (var i = payload.properties.length - 1; i >= 0; i--) {
      state.web3[payload.properties[i]] = payload.values[i]
      if (state.user[payload.properties[i]]) state.user[payload.properties[i]] = payload.values[i]
    }
  },
  [MUTATION_TYPES.LOGIN] (state, payload) {
    const userData = payload.userData
    const userCopy = state.user

    // userCopy = der aktuelle State und mit Assign werden nur die geänderten Eigenschaften kopiert
    Object.assign(userCopy, {
      firstName: userData.firstName,
      lastName: userData.lastName,
      email: userData.email,
      isLoggedIn: !!(userData.email && userData.email !== '') && state.user.hasCoinbase && state.user.isConnectedToApprovedNetwork
    })

    state.user = userCopy

    if (payload.callback) payload.callback(userData)
  },
  [MUTATION_TYPES.GETKEYS] (state, payload) {
    if (payload.userData.key.length > 0) {
      resetPublicKeys(state)
      state.user.hasKeys = true
      // Hier wird der State so manipuliert: Die Daten, die an die Blockchain gesendet werden, werden direkti
      // in den State geschrieben, müssen aber eigentlich gepusht werden
      console.log('MUTATION > GETKEYS')
      // Erstelle eine Array mit allen Währungen
      let deduplicatedCurs = Array.from(new Set(payload.userData.currency))

      for (let i = 0; i < deduplicatedCurs.length; i++) {
        state.publicKey.currency.push({
          cur: deduplicatedCurs[i],
          key: [],
          name: [],
          isDefault: []
        })
        for (let j = 0; j < payload.userData.key.length; j++) {
          if (deduplicatedCurs[i] === payload.userData.currency[j]) {
            state.publicKey.currency[i].key.push(payload.userData.key[j])
            state.publicKey.currency[i].name.push(payload.userData.name[j])
            state.publicKey.currency[i].isDefault.push(payload.userData.isDefault[j])
          }
        }
      }
      if (payload.callback) payload.callback(payload.userData)
    } else {
      console.log('MUTATION > GETKEYS > NO KEYS FOUND')
    }
  },

  [MUTATION_TYPES.LOGOUT] (state, payload) {
    resetUser(state)
    if (payload.callback) payload.callback()
  },
  [MUTATION_TYPES.CHANGE_CURRENT_ROUTE_TO] (state, newRoute) {
    state.currentRoute = newRoute
  }
}
