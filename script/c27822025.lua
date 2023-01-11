--奥西恩的歌声
function c27822025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,27822025+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c27822025.target)
	e1:SetOperation(c27822025.activate)
	c:RegisterEffect(e1)
end 
c27822025.XXSplash=true 
function c27822025.ckfil(c) 
	return c:IsFaceup() and c:IsCode(27822023,27822008,27822026)	
end 
function c27822025.filter(c,tp)
	return (c:IsType(TYPE_MONSTER) or Duel.IsExistingMatchingCard(c27822025.ckfil,tp,LOCATION_MZONE,0,1,nil)) and c.XXSplash
end
function c27822025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27822025.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27822025.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27822025.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

