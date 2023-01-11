--激流之公主-奥西恩
function c27822008.initial_effect(c) 
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c27822008.mfilter,2,99) 
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27822008,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetCost(c27822008.cpcost)
	e1:SetTarget(c27822008.cptg)
	e1:SetOperation(c27822008.cpop)
	c:RegisterEffect(e1) 
	--draw 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,27822008) 
	e2:SetCondition(c27822008.drcon)
	e2:SetTarget(c27822008.drtg) 
	e2:SetOperation(c27822008.drop) 
	c:RegisterEffect(e2) 
end
c27822008.XXSplash=true 
function c27822008.mfilter(c) 
	return c.XXSplash 
end
function c27822008.cpfilter(c)
	return c.XXSplash and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function c27822008.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c27822008.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.CheckLPCost(tp,1000) and Duel.IsExistingMatchingCard(c27822008.cpfilter,tp,LOCATION_GRAVE,0,1,nil)
	end 
	Duel.PayLPCost(tp,1000) 
	e:SetLabel(0) 
end
function c27822008.cpop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(c27822008.cpfilter,tp,LOCATION_GRAVE,0,nil) 
	if g:GetCount()<=0 then return end 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)==0 then return end  
	Duel.BreakEffect()
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject()) 
	Duel.ClearOperationInfo(0) 
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end 
end 
function c27822008.dckfil(c,e,tp)  
	local lg=e:GetHandler():GetLinkedGroup()
	return c:IsType(TYPE_LINK) and lg:IsContains(c) and c.XXSplash  
end 
function c27822008.drcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c27822008.dckfil,1,nil,e,tp) 
end 
function c27822008.drtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(1) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end 
function c27822008.drop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT) 
end 












