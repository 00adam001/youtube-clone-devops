import React from 'react';
import { render } from '@testing-library/react';
import App from './App';

describe('App', () => {
  test('renders without crashing', () => {
    render(<App />);
  });

  test('renders the app container', () => {
    const { container } = render(<App />);
    expect(container).toBeTruthy();
  });
});
