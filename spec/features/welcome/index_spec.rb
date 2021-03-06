require 'rails_helper'

describe 'As a user when I visit the welcome page' do
  it 'Has a welcome message, description of the app and login form' do
    visit root_path

    expect(page).to have_content('Welcome to Watch Party')
    expect(page).to have_content('This is an application to explore movies')
    expect(page).to have_link('I have an account')
    expect(page).to have_link('Sign Up')
  end
end
