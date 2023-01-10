ACTION _AddRemoveFromPool:
IF (connection.RequestPool.AddToPool > 0) THEN
  //Check the requested frame is not already in the list
  FOR i := 1 TO LIVE_DATA_MAX_POOL_SIZE DO
    IF (connection.RequestPool.PoolList[i] = connection.RequestPool.AddToPool) THEN
      connection.RequestPool.AddToPool := 0;
      EXIT;
    ELSIF (connection.RequestPool.PoolList[i] = 0) THEN
      EXIT;
    END_IF;
  END_FOR;

  IF (connection.RequestPool.AddToPool > 0) THEN //Check we haven't already found the request in the pool
    IF (connection.RequestPool.PoolListSize < LIVE_DATA_MAX_POOL_SIZE) THEN //Keep in range
      connection.RequestPool.PoolListSize := connection.RequestPool.PoolListSize + 1;
      connection.RequestPool.PoolList[connection.RequestPool.PoolListSize] := connection.RequestPool.AddToPool;
      connection.RequestPool.AddToPool := 0;
    END_IF;
  END_IF;
END_IF;
IF (connection.RequestPool.RemoveFromPool > 0) THEN
  //Find the pool in the array-- Remove it then shuffle the list.
  FOR i := 1 TO LIVE_DATA_MAX_POOL_SIZE DO
    IF (connection.RequestPool.PoolList[i] = connection.RequestPool.RemoveFromPool) THEN
      //Shuffle the list
      brsmemmove(ADR(connection.RequestPool.PoolList[i]),ADR(connection.RequestPool.PoolList[i + 1]),((LIVE_DATA_MAX_POOL_SIZE - i)*2));
      //connection.RequestPool.PoolList[LIVE_DATA_MAX_POOL_SIZE] := 0;
      connection.RequestPool.PoolListSize := connection.RequestPool.PoolListSize - 1;
      IF (connection.RequestPool.PoolListSize > LIVE_DATA_MAX_POOL_SIZE) THEN
        connection.RequestPool.PoolListSize := 0;
      END_IF;
      EXIT;
    ELSIF (connection.RequestPool.PoolList[i] = 0) THEN
      EXIT; //Not found
    END_IF;
  END_FOR;
  connection.RequestPool.RemoveFromPool := 0;
END_IF;
END_ACTION
