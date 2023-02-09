function c10105723.initial_effect(c)
	--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetCondition(c10105723.subcon)
	c:RegisterEffect(e2)
    	--deckdes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105723,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,10105723)
	e3:SetCondition(c10105723.ddcon)
	e3:SetTarget(c10105723.ddtg)
	e3:SetOperation(c10105723.ddop)
	c:RegisterEffect(e3)
        	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10105723,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCountLimit(1,10105723)
	e4:SetCondition(c10105723.drcon)
	e4:SetTarget(c10105723.drtg)
	e4:SetOperation(c10105723.drop)
	c:RegisterEffect(e4)
end
function c10105723.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_GRAVE)
end
function c10105723.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c10105723.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c10105723.ddop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	local c=e:GetHandler()
	local sync=c:GetReasonCard()
	if tc and tc:IsSetCard(0x9bc1) and tc:IsLocation(LOCATION_GRAVE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sync:RegisterEffect(e1)
	end
end
function c10105723.thfilter(c)
	return c:IsSetCard(0x9bc1) and c:IsAbleToHand()
end
function c10105723.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_FUSION)~=0 and c:GetReasonCard():IsSetCard(0x3bc2)
end
function c10105723.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105723.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,10105723)==0 end
	Duel.RegisterFlagEffect(tp,10105723,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10105723.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10105723.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(10105723,0))
end