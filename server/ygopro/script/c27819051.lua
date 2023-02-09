--五王-帝释天
function c27819051.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819051,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,27819051)
	e1:SetCost(c27819051.rhcost)
	e1:SetTarget(c27819051.target)
	e1:SetOperation(c27819051.operation)
	c:RegisterEffect(e1)
end
c27819051.SetCard_fiveking=true
function c27819051.rhcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c27819051.spfilter(c,e,tp)
	return c.SetCard_fiveking and c:IsLevelBelow(4) and not c:IsCode(27819051)
end
function c27819051.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c27819051.spfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c27819051.spfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function c27819051.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e)  then
		local code=tc:GetOriginalCodeRule()
		local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
		   local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		end
	end
end
ASE_END,1)
		end
	end
end
