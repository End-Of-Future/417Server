--超高校级•赤松枫
function c88882112.initial_effect(c)
	 --hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,88882112)
	e1:SetValue(c88882112.matval)
	c:RegisterEffect(e1) 
	--link effect 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88882112,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,18882112)
	e2:SetCondition(c88882112.lkcon)
	e2:SetTarget(c88882112.lktg)
	e2:SetOperation(c88882112.lkop) 
	c:RegisterEffect(e2)  
end
c88882112.ACGXJre=true 
function c88882112.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c.ACGXJre 
end
function c88882112.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(88882112)
end
function c88882112.matval(e,lc,mg,c,tp)
	if not lc.ACGXJre then return false,nil end
	return true,not mg or mg:IsExists(c88882112.mfilter,1,nil) and not mg:IsExists(c88882112.exmfilter,1,nil)
end
function c88882112.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK and e:GetHandler():GetReasonCard().ACGXJre
end 
function c88882112.tdfil(c) 
	return c:IsAbleToDeck() and c.ACGXJre and c:IsType(TYPE_MONSTER)	
end 
function c88882112.lktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(c88882112.tdfil,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c88882112.tdfil,tp,LOCATION_GRAVE,0,2,2,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c88882112.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if sg:GetCount()>0 and Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then 
	Duel.BreakEffect() 
	Duel.Draw(tp,1,REASON_EFFECT) 
	end 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c88882112.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c88882112.splimit(e,c)  
	return not c.ACGXJre and not c:IsLocation(LOCATION_EXTRA)
end 










