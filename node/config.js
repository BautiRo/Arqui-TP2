module.exports = {
  // Flag to determine whether to log debug information or not
  debug: true,

  // Number of cache keys
  cacheKeyLength:  10,

  // Base uri for remote python service
  remoteBaseUri: 'http://10.0.2.5:3000',

  // URL for alternate service
  alternateUrl: 'http://arquinchobauti.azurewebsites.net/api/alternate',

  // Options for creating redis client
  redis: {
    host: 'redis-arquincho-cache.redis.cache.windows.net',
    port: '6379',
    password: ''
  },

  datadog: {
    'response_code': true,
    'tags':          ['app:node']
  },
};
