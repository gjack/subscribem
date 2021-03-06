require 'rails_helper'
require 'support/subdomain_helpers'

feature 'User sign in' do
  extend SubdomainHelpers
  
  let!(:account) { FactoryGirl.create(:account) }
  let(:sign_in_url) {"http://#{account.subdomain}.example.com/sign_in"}
  let(:root_url) {"http://#{account.subdomain}.example.com/"}
  
  within_account_subdomain do
    scenario 'signs in as an account owner successfully' do
      visit root_url
      expect(page.current_url).to eq(sign_in_url)
      fill_in 'Email', with: account.owner.email
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
      
      expect(page).to have_content('You are now signed in.')
      expect(page.current_url).to eq(root_url)
    end
    
    scenario 'attempts sign in with invalid password and fails' do
      visit root_url
      expect(page.current_url).to eq(sign_in_url)
      expect(page).to have_content('Please sign in.')
      fill_in 'Email', with: account.owner.email
      fill_in 'Password', with: 'drowssap'
      click_button 'Sign in'
      expect(page).to have_content('Invalid email or password.')
      expect(page.current_url).to eq(sign_in_url)
    end
    
    scenario 'attempts to sign in with invalid email address and fails' do
      visit root_url
      expect(page.current_url).to eq(sign_in_url)
      expect(page).to have_content('Please sign in.')
      fill_in 'Email', with: 'foo@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
      expect(page).to have_content('Invalid email or password.')
      expect(page.current_url).to eq(sign_in_url)
    end
    
    scenario 'cannot sign in if not a part of this subdomain' do
      other_account = FactoryGirl.create(:account)
      visit root_url
      expect(page.current_url).to eq(sign_in_url)
      expect(page).to have_content('Please sign in.')
      fill_in 'Email', with: other_account.owner.email
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
      
      expect(page).to have_content('Invalid email or password.')
      expect(page.current_url).to eq(sign_in_url)
    end
  end
end