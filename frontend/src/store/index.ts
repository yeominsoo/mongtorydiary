import { configureStore } from '@reduxjs/toolkit'

export const store = configureStore({
  reducer: {
    // 여기에 slice 리듀서 추가
  },
})

// RootState 및 AppDispatch 타입 추론
export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch
